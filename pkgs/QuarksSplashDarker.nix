{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "quarks-splash-darker";
  version = "unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "tfwe";
    repo = "QuarksSplashDarker";
    rev = "main";
    sha256 = "sha256-Ld1u2J8qU0DCeYYO2f28y9YAvOzducrmcKxl07bnCmk=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plasma/look-and-feel/${pname}
    cp -r contents metadata.json $out/share/plasma/look-and-feel/${pname}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "QuarksSplashDarker KDE Splash Screen Theme for Plasma 6";
    homepage = "https://github.com/tfwe/QuarksSplashDarker";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tfwe ];
  };
}
