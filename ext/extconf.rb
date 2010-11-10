require 'mkmf'

if File.exist?(`which uuid-config`.chomp)
  $CFLAGS << " -Wall " << `uuid-config --cflags`.chomp
  lib_dir = `uuid-config --libdir`.chomp
  shared_lib = `grep -li uuid_create #{lib_dir}/*uuid*.so | grep -v ++`.chomp
  shared_lib = `uuid-config --ldflags`.chomp if shared_lib.empty?
  $LDFLAGS << " " << shared_lib
end

if !(have_library('uuid') || have_library('ossp-uuid'))
  puts "OSSP uuid library required -- not found."
  exit 1
end
create_makefile('uuid4r')
File.open("Makefile", "a") << <<-EOT

check:	$(DLLIB)
	@$(RUBY) #{File.dirname(__FILE__)}/../test/test_uuid.rb
EOT
