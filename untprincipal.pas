unit untPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  StrUtils;

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
  frmPrincipal                        : TfrmPrincipal;
  ArquivoDeConfiguracao               : TextFile;
  ArquivoDeConfiguracaoNome           : String;
  ArquivoDeConfiguracaoCaminho        : String;
  ArquivoDeConfiguracaoCaminhoCompleto: String;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure DefinirVariaveisGlobais;
begin
  ArquivoDeConfiguracaoNome  := 'AssinadorDigital.txt';

  // O arquivo de configuração fica no mesmo local do executável da aplicação
  ArquivoDeConfiguracaoCaminho:= ExtractFilePath(Application.ExeName);
  ArquivoDeConfiguracaoCaminhoCompleto:= ArquivoDeConfiguracaoCaminho +
                                         ArquivoDeConfiguracaoNome;

  if FileExists(ArquivoDeConfiguracaoCaminhoCompleto) then
  begin
    AssignFile(ArquivoDeConfiguracao,ArquivoDeConfiguracaoCaminhoCompleto);
  end;
end;

function SistemaOperacional:String;
begin
  {$IFDEF Linux}
    result:= 'Linux';
  {$ELSE}
    {$IFDEF WINDOWS}
      result:= 'Windows';
    {$ELSE}
      {$IFDEF UNIX}
        result:= 'Unix ';
      {$ELSE}
        {$IFDEF LCLcarbon}
          result:= 'Mac';
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function Executar:String;
begin
  // TODO executa um comando e retorna a resposta.
end;

function VerificarArquivos(Arquivo:String;Extensao:String):Boolean;
begin
  result:= false;

  if (FileExists(Arquivo)) and
     (LowerCase(ExtractFileExt(Arquivo)) = Extensao) then
  begin
    result:= true;
  end
  else if (FileExists(Arquivo)) and
          (LowerCase(ExtractFileExt(Arquivo)) <> Extensao) then
  begin
    MessageDlg('Erro ao Abrir Arquivo',
               'O arquivo ' + Arquivo  + ' não está no formato ' + Extensao +
               '.' + sLineBreak + 'Por favor selecione um arquivo com a '   +
               'extensão ' + Extensao + '.',mtError,[mbOK],0);
  end
  else
  begin
    MessageDlg('Erro ao Abrir Arquivo','O arquivo ' + Arquivo + ' não existe.',
               mtError,[mbOK],0);
  end;
end;

procedure ConfigurarOpcao(Opcao:String;Configuracao:String);
var
  Contador: Integer;
begin
  case Opcao of
    'JSignPDF': frmPrincipal.edtJsignpdf.Text:= Configuracao;
    'Java'    : frmPrincipal.edtJava.Text    := Configuracao;
    'Imagem'  : frmPrincipal.edtImagem.Text  := Configuracao;
  end;

  if Opcao = 'Padrao' then
  begin
    case Configuracao of
      'Documento': frmPrincipal.rdbDocumentos.Checked:= true;
      'DOMe'     : frmPrincipal.rdbDome.Checked     := true;
    end;
  end
  else if Opcao = 'Posicao' then
  begin
    case Configuracao of
      'Esquerda': frmPrincipal.rdbEsquerda.Checked:= true;
      'Centro'  : frmPrincipal.rdbCentro.Checked  := true;
      'Direita' : frmPrincipal.rdbDireita.Checked := true;
    end;
  end
  else if Opcao = 'Preservar' then
  begin
    case Configuracao of
    'Sim': frmPrincipal.ckbManterAssinaturas.Checked:= true;
    'Não': frmPrincipal.ckbManterAssinaturas.Checked:= false;
    end;
  end
  else if Opcao = 'Texto' then
  begin
    for Contador:= 1 to WordCount(Configuracao,['|']) do
    begin
      frmPrincipal.memTexto.Lines.AddStrings(ExtractWord(Contador,Configuracao,
                                                         ['|']));
    end;
  end;
end;

procedure SalvarOpcoes;
begin
  // TODO salvar as opções do sistema em um arquivo de configuração.
end;

procedure CarregarOpcoes;
var                  
  Linha           : String;
  Opcao           : String;
  Configuracao    : String; 
  ImagemLocal     : String;
  JsingPDFLocal   : String;
  JavaLocalLinux  : String;
  JavaLocalWindows: String;
begin
  // Configuração padrão da Imagem
  ImagemLocal:= ArquivoDeConfiguracaoCaminho + 'brasao.png';
  if FileExists(ImagemLocal) then
  begin
    frmPrincipal.edtImagem.Text:= ImagemLocal;
  end;

  // Configuração padrão do JsignPDF
  JsingPDFLocal:= ArquivoDeConfiguracaoCaminho + 'JsignPdf.jar';
  if FileExists(JsingPDFLocal) then
  begin
    frmPrincipal.edtJsignpdf.Text:= JsingPDFLocal;
  end;

  // Configuração padrão do Java
  JavaLocalLinux  := ArquivoDeConfiguracaoCaminho +
                     'java/linux/jre1.8.0_251/bin/java';
  JavaLocalWindows:= ArquivoDeConfiguracaoCaminho +
                     'java\windows\jre1.8.0_251\bin\javaw.exe';

  if (SistemaOperacional = 'Linux') and (FileExists(JavaLocalLinux)) then
  begin
    frmPrincipal.edtJava.Text:= JavaLocalLinux;
  end
  else if (SistemaOperacional = 'Windows') and
          (FileExists(JavaLocalWindows)) then
  begin
    frmPrincipal.edtJava.Text:= JavaLocalWindows;
  end;

  // Sobrescreve configurações padrão se existir arquivo de configuração
  if FileExists(ArquivoDeConfiguracaoCaminhoCompleto) then
  begin
    try
      Reset(ArquivoDeConfiguracao);
      while not eof(ArquivoDeConfiguracao) do
      begin
        ReadLn(ArquivoDeConfiguracao,Linha);
        Opcao       := ExtractWord(1,Linha,['=']);
        Configuracao:= ExtractWord(2,Linha,['=']);
        ConfigurarOpcao(Opcao,Configuracao);
      end;
      CloseFile(ArquivoDeConfiguracao);
    Except
    on E: EInOutError do
      MessageDlg('Erro abrir o arquivo de configuração.',
                 PChar(E.Message),mtError,[mbOK],0);
    end;
  end;
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
  DefinirVariaveisGlobais;
  CarregarOpcoes;
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

