require 'etc'
require 'io/console'

conftext = File.read("/bin/fort.config", "w")
config = eval("#{conftext}")
exitcode = "fort: Permission denied"

def execute_command_as_root(command)
  uid = Process::UID.eid
  gid = Process::GID.eid

  if require_root_password?
    print '[password]: '
    password = STDIN.noecho(&:gets).chomp

    unless check_root_password(password)
      puts exitcode
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
    puts exitcode
  end
end

command = ARGV[0]
status = execute_command_as_root(command)
