class Huedollar < Formula
  desc "Get's dollar conversion rates on your notifications"
  homepage "git@github.com:alansikora/huedollar.git"
  url "https://github.com/alansikora/huedollar/archive/0.1.tar.gz"
  sha256 "a095ed49bba5680be8a54530ea794815b83cd7b22dda352dd79df2e119f598e3"
  revision 1

  bottle do
    cellar :any
  end

  head do
    url "https://github.com/alansikora/huedollar.git"
  end

  depends_on "jq"

  def install
    # system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
