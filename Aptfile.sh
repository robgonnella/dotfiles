sudo apt update && sudo apt install -y \
  build-essential \
  curl \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxmlsec1-dev \
  snapd \
  tk-dev \
  xz-utils \
  zlib1g-dev

if ! command -v docker; then
  curl -fsSL https://get.docker.com | sudo sh -
  sudo systemctl enable docker
  sudo groupadd docker || true
  sudo usermod -aG docker $USER
fi