require "formula"

class EnigmaGame < Formula
  homepage ""
  url "https://downloads.sourceforge.net/project/enigma-game/Release%201.21/enigma-1.21.tar.gz"
  sha1 "6ca021de7516308e353eefc52765b519e1558ee8"

  option "make-autogen", "Run autogen before make (default for --HEAD)"
  option "make-preview", "Generate and cache the level previews (slow)"
  option "make-gmo", "Generate the gmo files (default for --HEAD)"

  head "https://github.com/sidney/Enigma.git", :branch => "sdl2-scaling"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2" => :build
  depends_on "sdl2_image" => :build
  depends_on "sdl2_mixer" => :build
  depends_on "sdl2_ttf" => :build
  depends_on "gettext" => :build
  depends_on "freetype" => :build
  depends_on "xerces-c" => :build
  depends_on "libjpeg"
  depends_on "libpng" => :build
  depends_on "imagemagick" => :build
  depends_on "osxutils" => :build
  depends_on "texi2html" => :build

  def install
    ENV.deparallelize
    if build.head? or build.include? "make-autogen"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
      			  "--with-libintl-prefix=#{Formula['gettext'].opt_prefix}",
                          "--prefix=#{prefix}"
    if build.head? or build.include? "make-gmo"
      system "make", "gmo"
    end
    system "make"
    system "make", "macapp"
    if build.head? or build.include? "make-preview"
      system "make", "macpreview"
    end
    system "make", "macdmg"
    share.install "etc/enigma.dmg"
  end

  test do
    system "hdiutil detach -quiet /Volumes/Enigma || true"
    system "hdiutil attach -quiet /usr/local/share/enigma.dmg"
    system "/Volumes/Enigma/Enigma.app/Contents/MacOS/enigma --version"
    system "hdiutil detach -quiet /Volumes/Enigma"
  end
end
