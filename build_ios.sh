fvm flutter clean;
fvm flutter pub get;
cd ios;
rm -rf Podfile.lock;
pod deintegrate;  
pod install; 
pod repo update;
cd ..;