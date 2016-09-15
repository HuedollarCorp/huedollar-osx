class Huedollar < Formula
  attr_accessor :interval

  desc "Dollar conversion rates on your notifications"
  homepage ""
  url "https://github.com/alansikora/huedollar/archive/v1.0.1.tar.gz"
  version "1.0.1"
  sha256 "0a6bd148e9adde556a1a19f9832461efb49e20fe348de11224234f89b760abe8"

  depends_on "jq"

  def install
    (prefix).install "huedollar.sh"

    unless File.file?(prefix/"huedollar-stash")
      (prefix/"huedollar-stash").write <<-EOS.undent
        LAST_DAY_DOLLAR=0.0000
        OLD_DOLLAR_B=0.0000
        OLD_DOLLAR_A=0.0000
      EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>WorkingDirectory</key>
        <string>#{prefix}</string>

        <key>Label</key>
        <string>#{plist_name}</string>

        <key>ProgramArguments</key>
        <array>
            <string>/bin/bash</string>
            <string>huedollar.sh</string>
        </array>

        <key>StartInterval</key>
        <integer>600</integer>
    </dict>
    </plist>
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test huedollar`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
