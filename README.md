# SnowmanLabs Challenge

App de testes deenvolvido para iOS com Flutter


## Features
 - Login/Cadastro via Facebook
 - Visualizar no mapa pontos turísticos em um raio de 5km da posição atual (também possível ver ao mudar o centro do mapa - apenas para fins de testes)
 - Busca de pontos turísticos por nome
 - Cadastro de pontos turísticos (Imagem, Nome, Posição e Categoria)
 - Adicionar ponto turístico aos favoritos
 - Ver pontos turísticos favoritos
 - Remover pontos turísticos dos favoritos
 - Avaliar com nota e comentário o ponto turístico
 - Ver os pontos turisticos criados pelo usuário
 
 ### Próximos passos?
  - Melhorar a estrutura de código componentizando melhor alguns pontos
  - Usar a APIKey dos serviços através de variáveis de ambiente evitando hard coded
  - Melhorar UI das listas de favoritos/cadastrados
  - Logout
  - Indicador de loading nas requisições
  - Alterar cores dos marcadores
  - Testes Unitários e de Widgets
 
 #### Tecnologia e Pacotes utilizados
 
Utilizei o Framework Flutter + Firebase + Google Maps

Foram utilizados os pacotes:
 - google_maps_flutter: ^0.5.25+2
 - cloud_firestore: ^0.13.4+2
 - json_annotation: any
 - provider: ^4.0.4
 - flutter_rating_bar: ^3.0.1+1
 - location: ^3.0.1
 - geoflutterfire: ^2.1.0
 - geolocator: ^5.3.1
 - rxdart: ^0.23.1
 - flutter_facebook_login: ^3.0.0
 - firebase_auth: ^0.15.5+3
 - flutter_typeahead: ^1.8.0
 - uuid: ^2.0.4
 - firebase_core: ^0.4.4+3
 - firebase_storage: ^3.1.5
 - image_picker: ^0.6.4
 - device_info: ^0.4.2+1
 
##### Considerações
 - Algumas telas não estão disponíveis no <a href="https://invis.io/84URZA9RTQF">
        Design »
    </a> como Listagem de Favoritos e pontos cadastrados
 - Testei apenas no emulador iOS, desta forma a captura de foto é feita através da galeria. Em dispositivo real ele irá abrir a câmera para captura de imagem
 - Demorei mais que devia pois estou com meu filho em casa devido as novidades do COVID-19 e trabalho em período comercial
 - A tela de formulário de cadastro não condiz exatamente com as User Stories (divergência de campos e informações)
 - Demorei mais que devia pois estou com meu filho em casa devido as novidades do COVID-19 e trabalho em período comercial
