unit untPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnArquivoSelecionar: TButton;
    btnImagemSelecionar1: TButton;
    btnJsignpdfSelecionar: TButton;
    btnJavaSelecionar: TButton;
    btnSalvarOpcoes: TButton;
    btnAssinar: TButton;
    ckbMaisOpcoes: TCheckBox;
    ckbManterAssinaturas: TCheckBox;
    edtArquivo: TEdit;
    edtImagem: TEdit;
    edtJsignpdf: TEdit;
    edtJava: TEdit;
    edtSenha: TEdit;
    gbxMaisOpcoes: TGroupBox;
    imgTitle: TImage;
    imgCabecalho: TImage;
    lblImagem: TLabel;
    lblJsignpdf: TLabel;
    lblJava: TLabel;
    lblTexto: TLabel;
    lblArquivo: TLabel;
    lblSenha: TLabel;
    memTexto: TMemo;
    pnlCabecalho: TPanel;
    pnlOpcoes: TPanel;
    pnlMaisOpcoes: TPanel;
    rdbDocumentos: TRadioButton;
    rdbDome: TRadioButton;
    rdbEsquerda: TRadioButton;
    rdbCentro: TRadioButton;
    rdbDireita: TRadioButton;
    rdgTipoDeDocumento: TRadioGroup;
    rdgPosicaoDaAssinatura: TRadioGroup;
    tgbExibir: TToggleBox;
    procedure btnArquivoSelecionarClick(Sender: TObject);
    procedure btnAssinarClick(Sender: TObject);
    procedure btnImagemSelecionar1Click(Sender: TObject);
    procedure btnJavaSelecionarClick(Sender: TObject);
    procedure btnJsignpdfSelecionarClick(Sender: TObject);
    procedure btnSalvarOpcoesClick(Sender: TObject);
    procedure edtArquivoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tgbExibirChange(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

function SistemaOperacional:String;
begin
  // TODO retorna o sistema operacional onde está sendo executado.
end;

function Executar:String;
begin
  // TODO executa um comando e retorna a resposta.
end;

function VerificarArquivos:String;
begin
  // TODO verifica a existência ou validade dos arquivos e retorna a resposta.
end;

procedure ConfigurarOpcao(Opcao:String;Configuracao:String);
begin
  // TODO configura as opções do sistema de acordo com a configuração desejada.
end;

procedure SalvarOpcoes;
begin
  // TODO salvar as opções do sistema em um arquivo de configuração.
end;

procedure AbrirOpcoes;
begin
  // TODO verificar se o arquivo de configurações existe.
  // TODO abre o arquivo com as configurações salvas e configura as opções.
  // TODO caso as configurações não existam, confugura as opções padrão.
  //      (verifica se existe o arquivo executável Java e o Jsignpdf.jar
  //       na pasta de execução do Assinador PMBD).
end;

procedure AssinarArquivo;
begin
  // TODO verificar se o arquivo selecionado existe.
  // TODO verificar se o arquivo selecionado é um PDF.
  // TODO verificar se os arquivos de mais opções existem.
  // TODO elabora o comando de acordo com as opções desejadas.
  // TODO assina o arquivo selecionado.
  // TODO exibe um aviso se o arquivo tiver sido assinado ou não
  // TODO caso o arquivo tenha sido assinado, pergunta se deseja abrir.
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  // TODO carregar as opções salvas caso existam.
  // TODO verificar de qual o sistema operacional está sendo executado.
  // TODO configurar interface de acordo com o sistema operacional.
  // TODO verificar se os arquivos de mais opções existem.
end;

procedure TfrmPrincipal.tgbExibirChange(Sender: TObject);
begin
  // TODO caso esteja marcado, exibe a senha em texto puro.
end;

procedure TfrmPrincipal.btnArquivoSelecionarClick(Sender: TObject);
begin
  // TODO abre uma caixa de diálogo para selecionar o arquivo a ser assinado.
end;

procedure TfrmPrincipal.btnAssinarClick(Sender: TObject);
begin
  // TODO dispara o processo de assinar o documento.
end;

procedure TfrmPrincipal.btnImagemSelecionar1Click(Sender: TObject);
begin
  // TODO abre uma caixa de diálogo para selecionar a imagem do carimbo.
end;

procedure TfrmPrincipal.btnJavaSelecionarClick(Sender: TObject);
begin
  // TODO abre uma caixa de diálogo para selecionar o executável do Java.
end;

procedure TfrmPrincipal.btnJsignpdfSelecionarClick(Sender: TObject);
begin
  // TODO abre uma caixa de diálogo para selecionar o JsignPDF.jar.
end;

procedure TfrmPrincipal.btnSalvarOpcoesClick(Sender: TObject);
begin
  // TODO dispara o processo de salvar opções.
end;

procedure TfrmPrincipal.edtArquivoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // TODO dispara o processo de assinar o documento.
end;

end.

