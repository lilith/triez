require 'mkmf'

# Set up compiler flags for hat-trie and C++
$CFLAGS << ' -Ihat-trie'
$CPPFLAGS << ' -Ihat-trie'
# Force C++ linking since we have C++ source files
CONFIG['LDSHARED'] = CONFIG['LDSHARED'].gsub(/gcc/, 'g++')
# Keep CC as gcc for C files, we'll handle C++ separately

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

# Add custom build rules for hat-trie
File.open 'Makefile', 'a' do |f|
  f.puts
  f.puts "# Hat-trie library build"
  f.puts "HATTRIE_OBJS = hat-trie/ahtable.o hat-trie/hat-trie.o hat-trie/misc.o hat-trie/murmurhash3.o"
  f.puts
  f.puts "$(DLLIB): $(OBJS) $(HATTRIE_OBJS)"
  f.puts "\tg++ -shared -o $@ $(OBJS) $(HATTRIE_OBJS) $(LDFLAGS) $(LOCAL_LIBS) $(LIBS)"
  f.puts
  f.puts "hat-trie/%.o: hat-trie/%.c"
  f.puts "\tgcc $(CFLAGS) -std=c99 -fPIC -c $< -o $@"
  f.puts
  f.puts "triez.o: triez.cc"
  f.puts "\tg++ $(CPPFLAGS) $(INCFLAGS) -fPIC -c $< -o $@"
  f.puts
  f.puts "clean: clean-hattrie"
  f.puts "clean-hattrie:"
  f.puts "\t-$(RM) $(HATTRIE_OBJS)"
end