require 'etc'
require 'io/console'

config = eval(File.read("/bin/fort.config"))
exitcodes = [
  "fort: Permision denied"
]

def execute_command_as_root(command)
  uid = Process::UID.eid
  gid = Process::GID.eid

  if require_root_password?
    print '[password]: '
    password = STDIN.noecho(&:gets).chomp
    unless check_root_password(password)
      puts exitcodes[0]
      return false
    end
  end

  Process.fork do
    Process::Sys.setuid(uid)
    Process::Sys.setgid(gid)

    exec command
  end

  _, status = Process.wait2
  status
end

def require_root_password?
  return PassRequire
end

def check_root_password(password)
  if password != pass
    puts exitcodes[0]
  end
end

command = ARGV[0]
status = execute_command_as_root(command)
