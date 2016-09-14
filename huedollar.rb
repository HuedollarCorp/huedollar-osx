class Huedollar < Formula
  desc "Get's dollar conversion rates on your notifications"
  homepage ""
  url "https://github.com/alansikora/huedollar/archive/0.1.tar.gz"
  version "0.1"
  sha256 "d1103be48e44dd1728890f76030d1e1f5ab69aa81cb05e0340c9f9b002cbf5f0"

  depends_on "jq"

  option "interval", "Overrides default interval, which is 30 minutes"

  def install
    # (libexec/"zeronet").install Dir["*"]
    # (bin/"zeronet").write <<-EOS.undent
    #   #!/usr/bin/env bash
    #   cd #{libexec}/zeronet/
    #   env PYTHONPATH=#{libexec}/vendor/lib/python2.7/site-packages:${PYTHONPATH} python zeronet.py "${@}"
    # EOS

    puts options

    (prefix).install "huedollar.sh"

    system "touch", "#{prefix}/dollar.txt"
    system "touch", "#{prefix}/last_day_dollar.txt"

    sdasda123
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
        <integer>15</integer>
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
