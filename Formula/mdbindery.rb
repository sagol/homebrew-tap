class Mdbindery < Formula
  include Language::Python::Virtualenv

  desc "Turn Markdown chapters into a validated EPUB 3 ebook"
  homepage "https://github.com/sagol/mdbindery"
  url "https://github.com/sagol/mdbindery/releases/download/v0.1.0/mdbindery-0.1.0.tar.gz"
  sha256 "39baa108bc48dd353aeedcb7e7aa4eab6d13871145f5c624cc35610e80ed02b5"
  license "MIT"

  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      mdbindery keeps pandoc, EPUBCheck, Node.js, mermaid-cli, and Ace in its own
      tool home. Download them once with:
        mdbindery install-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdbindery --version")
    system libexec/"bin/python", "-c", "import PIL, yaml"
    (testpath/"book/01-a.md").write "# A\n\nText.\n"
    assert_match "mdbindery check", shell_output("#{bin}/mdbindery check #{testpath}/book --no-render")
  end
end
