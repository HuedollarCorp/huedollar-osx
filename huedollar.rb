class Huedollar < Formula
  attr_accessor :interval

  desc "Dollar conversion rates on your notifications"
  homepage ""
  url "https://github.com/alansikora/huedollar/archive/v1.0.2.tar.gz"
  version "1.0.2"
  sha256 "a8d0520c6075fd4773a58ada5be3f64feb5bbca5db81e97bf7274e01d4a773fe"

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
    system "false"
  end
end
