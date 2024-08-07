# Project and directory-relative require for local libraries.

# setup helper for macros
{% begin %}
  {% root = system("pwd").strip %}
  ROOT = "{{ root.id }}"
  
  {% rel_local_lib = __DIR__[root.size..].gsub(%r{\\}, "/").split('/')[..-2].join("/") + "" %}
  REL_LOCAL_LIB = "{{ rel_local_lib.id }}"
  
  {% local_lib = root + rel_local_lib %}
  LOCAL_LIB = "{{ local_lib.id }}"
{% end %}

# usage:
# when need to require a library from the same dir as this
# library originates from, ie:
# - this  : @project_root/lib_local/require
# - want  : @project_root/lib_local/somelib
# - origin: @project_root/src/ ...
# do:
# - `require_local_lib "somelib/somefile"`
macro require_local_lib(file)
  {% caller_filename_posix = @caller.first.filename[ROOT.size..].gsub(%r{\\}, "/") %}
  {% relative_root = caller_filename_posix.gsub(%r{[^/]+}, "..")[4..] %}
  
  {% require_path = relative_root + REL_LOCAL_LIB + '/' + file %}
  require "{{ require_path.id }}"
end

# usage:
# - `import MyApp::SomeNamespace::Things::MyClass`
macro import(type)
  private alias {{type.stringify.split("::").last}} = {{type}}
end
