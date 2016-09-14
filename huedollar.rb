class Huedollar < Formula
  attr_accessor :interval

  desc "Dollar conversion rates on your notifications"
  homepage ""
  url "https://github.com/alansikora/huedollar/archive/0.3.1.tar.gz"
  version "0.3.1"
  sha256 "b74730d1c66ec37f7bf71e33e6c4ee845eae3bb6cd0e36a039195db0385bc994"

  depends_on "jq"

  option "with-15s-interval"
  option "with-15m-interval"
  option "with-30m-interval"
  option "with-60m-interval"

  def install
    self.interval = 15 * 60 # defaults to 15 minutes

    if build.with? "15s-interval"
      self.interval = 15
    end

    if build.with? "15m-interval"
      self.interval = 15 * 60
    end

    if build.with? "30m-interval"
      self.interval = 30 * 60
    end

    if build.with? "60m-interval"
      self.interval = 60 * 60
    end

    (prefix).install "huedollar.sh"

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
        <integer>#{self.interval}</integer>
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
