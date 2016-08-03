import subprocess
import os

def get_git_revision_short_hash():
    try:
        sha = subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD']).strip()
    except Exception:
        sha = "not a git repo"
    return sha

def get_build_url():
    url = os.getenv("BUILD_URL")
    if url is None:
        url = "$BUILD_URL unset"
    return url


if __name__ == "__main__":
    print "sha:", get_git_revision_short_hash()
    print "build_url:", get_build_url()

