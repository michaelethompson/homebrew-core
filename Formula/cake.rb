class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v0.34.0/Cake-bin-net461-v0.34.0.zip"
  sha256 "effc6e0bef0f5b6453017060c9a7882389dc1c369bc615d6d1370729b05ea304"

  bottle :unneeded

  depends_on "mono"

  conflicts_with "coffeescript", :because => "both install `cake` binaries"

  def install
    libexec.install Dir["*.dll"]
    libexec.install Dir["*.exe"]
    libexec.install Dir["*.xml"]

    bin.mkpath
    (bin/"cake").write <<~EOS
      #!/bin/bash
      mono #{libexec}/Cake.exe "$@"
    EOS
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
