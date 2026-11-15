"""smoke.py ALLURE_BINARY: start the game in an 80x45 pseudo-terminal from
another directory, with an empty HOME and a scratch XDG_STATE_HOME, and
fail unless the ANSI frontend drew the main menu and the game made its
folder in XDG_STATE_HOME/allure."""
import fcntl, os, pty, select, signal, struct, sys, tempfile, termios, time

binary = os.path.abspath(sys.argv[1])
home = tempfile.mkdtemp()
state = tempfile.mkdtemp()
os.chdir(tempfile.mkdtemp())
pid, fd = pty.fork()
if pid == 0:
    os.environ.clear()
    os.environ.update(TERM="xterm-256color", HOME=home, XDG_STATE_HOME=state,
                      PATH="/usr/bin:/bin", LANG="C.UTF-8")
    os.execv(binary, [binary])
fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 45, 80, 0, 0))

def read_for(seconds):
    out, end = b"", time.time() + seconds
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.2)
        if r:
            try:
                out += os.read(fd, 65536)
            except OSError:
                break
    return out

out = read_for(8)
os.kill(pid, signal.SIGKILL)
text = out.decode("utf-8", "replace")
print(f"{len(out)} bytes of output")
if "too small" in text or len(out) < 2000:
    print(text[-2000:])
    sys.exit("smoke test failed: the game did not draw its screen")
if not os.path.isdir(os.path.join(state, "allure")):
    sys.exit("smoke test failed: no folder in XDG_STATE_HOME/allure")
if os.path.exists(os.path.join(home, ".Allure")):
    sys.exit("smoke test failed: the game wrote to ~/.Allure")
print("ok: the game drew its screen and keeps its files in the state folder")
