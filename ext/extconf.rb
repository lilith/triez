require 'mkmf'

# Set up compiler flags for hat-trie and C++
$CFLAGS << ' -Ihat-trie'
$CPPFLAGS << ' -Ihat-trie'
# Force C++ linking since we have C++ source files
CONFIG['LDSHARED'] = CONFIG['LDSHARED'].gsub(/gcc/, 'g++')
CONFIG['CC'] = 'g++'

# Ensure hat-trie sources are available (they should be vendored)
unless File.exist?('hat-trie/hat-trie.h')
  abort "hat-trie sources not found in ext/hat-trie/ - they should be vendored with the gem"
end

# Check for required headers - make them optional to avoid build failures
have_header('ruby/thread.h')
have_func('rb_thread_call_without_gvl')

# Ensure we can find the Ruby headers
unless have_header('ruby.h')
  abort "ruby.h not found. Please ensure Ruby development headers are available."
end

unless have_header('ruby/encoding.h')
  abort "ruby/encoding.h not found. Please ensure Ruby development headers are available."
end

create_makefile 'triez'

# respect header changes
headers = Dir.glob('*.{hpp,h}').join ' '
File.open 'Makefile', 'a' do |f|
  f.puts
  f.puts "$(OBJS): #{headers}"
  f.puts "$(DLLIB): build/libtries.a $(OBJS)"
  f.puts "\t$(LDSHARED) -o $@ $(OBJS) build/libtries.a $(LDFLAGS) $(LOCAL_LIBS) $(LIBS)"
  f.puts "build/libtries.a:"
  ar_opt = \
    if defined? CONFIG and CONFIG['AR'] =~ /libtool/
      "-o" # libtool -static -o
    else
      "rcs"
    end
  f.puts "\tmkdir -p build && cd build && $(CC) -O3 -std=c99 -Wall -pedantic -fPIC -c -I.. ../hat-trie/*.c && $(AR) #{ar_opt} libtries.a *.o"
end