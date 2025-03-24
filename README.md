# Kosher Argentina
Una aplicacion con todas las listas Kosher de la region, sencillo y facil de usar.
---
---

## caracteristicas
- Productos divididos por categorias
- Supervicion rabinica a la vista
- Busqueda por codigo de barras
- Simbolo de celiaco a la vista
- Busqueda por nombre del producto
- Busqueda por marca
- Busqueda por codigo de barras
- filtros pora diferentes niveles de kashrut
- alertas de Ajdut Kosher
- filtro: Pesaj - Sin Kitniot
- filtro: Solo Mehadrin




### Tareas:
- [x] agregar descripcion de la categoria al inicio de la lista de productos.
- [x] agregar las alertas de ajdut kosher
- [ ] agregar debouncer en search
- [ ] revisar todos
- [ ] pasar pedidos de datos a un cubit
- [ ] agregar lista de uk, brasil (dbk), usa (ou), otros rabinatos.


- [https://romannurik.github.io/AndroidAssetStudio/index.html] Icon Generetor and more

SHA1 - SHA256
to create new:
keytool -genkey -v -keystore ./android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload -deststoretype pkcs12

to see:
keytool -list -v -keystore ./android/app/release-key.keystore
keytool -list -v -keystore ./android/app/upload-keystore.jks

cd android
./gradlew signingreport

flutter build apk
flutter build aab

https://appscreens.com/user/project/3hOmMG4M8Te0k9CwwkCA

https://app.quicktype.io/