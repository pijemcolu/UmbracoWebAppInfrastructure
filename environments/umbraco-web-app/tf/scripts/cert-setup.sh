
# CSR generation

openssl req -new -newkey rsa:2048 -nodes -keyout mikulas.dev.key -out mikulas.dev.csr
cat mikulas.dev.csr

# Certificate conversion to pfx
openssl pkcs7 -print_certs -in mikulas_dev.p7b -out mikulas_dev.pem
openssl pkcs12 -export -out mikulas_dev.pfx -inkey mikulas.dev.key -in mikulas_dev.pem
