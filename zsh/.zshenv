export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export LDFLAGS="-L/usr/local/opt/python@3.9/lib"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export LDFLAGS="-L/usr/local/opt/sqlite/lib"

export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/python@3.9/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"

export JAVA_HOME=$(/usr/libexec/java_home)

export PKG_CONFIG_PATH="/usr/local/opt/python@3.9/lib/pkgconfig"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

. "$HOME/.cargo/env"
