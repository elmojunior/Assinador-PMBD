# Assinador PMBD

Desenvolvimento de um software para assinar arquivos no formato PDF, na Prefeitura Municipal de Bom Despacho, Minas Gerais. Trata-se de uma interface gráfica para o JsignPDF.

![Imagem de Tela](https://raw.githubusercontent.com/elmojunior/Assinador-PMBD/master/Imagens/Screenshot.png)

## Dependências

- **Java (versão 1.8):** utilizado para executar o JsignPDF;
- **JsignPDF (versão 1.6.1):** utilizado para assinar documentos;
- **Token:** este aplicativo foi desenvolvido exclusivamente para certificados digitais com token.

### Java

Este sistema funcina com o OpenJDK ou o Oracle Java. A seguir estão as instruções para instalar cada uma das opções.

#### OpenJDK (Linux)

- Ubuntu e derivados:
    ```bash
    sudo apt install openjdk-8-jre
    ```
    
- Fedora:
    ```bash
    sudo dnf install openjdk-8-jre
    ```
    
#### Oracle Java

- Ubuntu e derivados _(fonte: http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html)_:
    ```bash
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer
    ```
- Microsof Windows: faça o download da instalação pelo site oficial https://www.java.com/pt_BR/download/.   
 
### JsignPDF

- Para todos os sistemas: faça o download pelo Source Forge https://sourceforge.net/projects/jsignpdf/files/stable/JSignPdf%201.6.1/JSignPdf-1.6.1.zip/download.

### Token

Você pode encontrar a instalação do token no site da certificadora. Mas a Certifica Minas disponibiliza várias opções de download em seu site https://certificaminas.com/instaladores-e-drives.

#### Hierarquia de Certificação

Caso seja necessário instalar alguma hierarquia de certificação, você pode verificar se foi disponibilizado pela  Valid certificadora em seu site https://www.validcertificadora.com.br/Home-Instalacao-e-Suporte-hierarquia-de-certificacao/D25.
 
## Homologação

Este sistema foi elaborado e testado nos sistemas:

- KDE Neon 5.18.5 64-bits;
- Linux Mint 18.3 64-bits;
- Microsoft Windows 7 Professional 32-bits e 64-bits.

## Desenvolvimento

Foi utilizdo a liguagem FreePascal com a IDE Lazarus (versão 2.0.8). Para fazer o download, acesse o site oficial pelo link https://www.lazarus-ide.org/index.php?page=downloads.

## Licença

>Este programa é um software livre; você pode redistribuí-lo e/ou
>modificá-lo sob os termos da Licença Pública Geral GNU como publicada
>pela Free Software Foundation; na versão 3 da Licença, ou
>(a seu critério) qualquer versão posterior.
>
>Este programa é distribuído na esperança de que possa ser útil,
>mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO
>a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a
>Licença Pública Geral GNU para mais detalhes.
>
>Você deve ter recebido uma cópia da Licença Pública Geral GNU junto
com este programa. Se não, veja <http://www.gnu.org/licenses/>.

