unit untPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, StrUtils;

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
    opdArquivo: TOpenDialog;
    opdJsignpdf: TOpenDialog;
    opdJava: TOpenDialog;
    opdImagem: TOpenPictureDialog;
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
  ArquivoDeConfiguracaoNome  := 'AssinadorPMBD.txt';
  // O arquivo de configuração fica no mesmo local do executável da aplicação
  ArquivoDeConfiguracaoCaminho:= ExtractFilePath(Application.ExeName);
  ArquivoDeConfiguracaoCaminhoCompleto:= ArquivoDeConfiguracaoCaminho +
                                         ArquivoDeConfiguracaoNome;
  AssignFile(ArquivoDeConfiguracao,ArquivoDeConfiguracaoCaminhoCompleto);
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
    'JsignPdf': frmPrincipal.edtJsignpdf.Text:= Configuracao;
    'Java'    : frmPrincipal.edtJava.Text    := Configuracao;
    'Imagem'  : frmPrincipal.edtImagem.Text  := Configuracao;
  end;

  if Opcao = 'Tipo' then
  begin
    case Configuracao of
      'Documentos': frmPrincipal.rdbDocumentos.Checked:= true;
      'DOMe'      : frmPrincipal.rdbDome.Checked      := true;
    end;
  end
  else if Opcao = 'Posição' then
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
  try
    Rewrite(ArquivoDeConfiguracao);

    // Salva o tipo de documento
    case frmPrincipal.rdbDocumentos.Checked of
      true : WriteLn(ArquivoDeConfiguracao,'Tipo=Documentos');
      false: WriteLn(ArquivoDeConfiguracao,'Tipo=DOMe');
    end;

    // Salva a posição da assinatura
    if frmPrincipal.rdbEsquerda.Checked then
    begin
      WriteLn(ArquivoDeConfiguracao,'Posição=Esquerda');
    end
    else if frmPrincipal.rdbCentro.Checked then
    begin
      WriteLn(ArquivoDeConfiguracao,'Posição=Centro');
    end
    else if frmPrincipal.rdbDireita.Checked then
    begin
      WriteLn(ArquivoDeConfiguracao,'Posição=Direita');
    end;

    // Salva manter assinaturas
    case frmPrincipal.ckbManterAssinaturas.Checked of
      true : WriteLn(ArquivoDeConfiguracao,'Preservar=Sim');
      false: WriteLn(ArquivoDeConfiguracao,'Preservar=Não');
    end;

    // Salva o texto
    frmPrincipal.memTexto.Lines.Delimiter      := '|';
    frmPrincipal.memTexto.Lines.StrictDelimiter:= true;
    WriteLn(ArquivoDeConfiguracao,'Texto=' + frmPrincipal.memTexto.Lines.DelimitedText);

    // Salva demais opções
    WriteLn(ArquivoDeConfiguracao,'Imagem='   + frmPrincipal.edtImagem.Text);
    WriteLn(ArquivoDeConfiguracao,'JsignPdf=' + frmPrincipal.edtJsignpdf.Text);
    WriteLn(ArquivoDeConfiguracao,'Java='     + frmPrincipal.edtJava.Text);

    CloseFile(ArquivoDeConfiguracao);
    MessageDlg('Salvar Configuração','Seu arquivo de configuração foi salvo com sucesso.',mtInformation,[mbOK],0);
  Except
    on E: EInOutError do
      MessageDlg('Erro salvar arquivo de configuração.',PChar(E.Message),mtError,[mbOK],0);
  end;
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
end;

procedure TfrmPrincipal.tgbExibirChange(Sender: TObject);
begin
  case tgbExibirSenha.Checked of
    true : edtSenha.EchoMode:= emNormal;
    false: edtSenha.PasswordChar:= '*';
  end;
end;

procedure TfrmPrincipal.btnArquivoSelecionarClick(Sender: TObject);
begin
  if opdArquivo.Execute then edtArquivo.Text:= opdArquivo.Filename;
end;

procedure TfrmPrincipal.btnAssinarClick(Sender: TObject);
begin
  // TODO dispara o processo de assinar o documento.
end;

procedure TfrmPrincipal.btnImagemSelecionar1Click(Sender: TObject);
begin
  if opdImagem.Execute then edtImagem.Text:= opdArquivo.Filename;
end;

procedure TfrmPrincipal.btnJavaSelecionarClick(Sender: TObject);
begin
  if opdJava.Execute then edtJava.Text:= opdArquivo.Filename;
end;

procedure TfrmPrincipal.btnJsignpdfSelecionarClick(Sender: TObject);
begin
  if opdJsignpdf.Execute then edtJsignpdf.Text:= opdArquivo.Filename;
end;

procedure TfrmPrincipal.btnSalvarOpcoesClick(Sender: TObject);
begin
  SalvarOpcoes;
end;

procedure TfrmPrincipal.edtArquivoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // TODO dispara o processo de assinar o documento.
end;

end.

