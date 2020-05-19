unit untPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, StrUtils, FileUtil, Process, lclintf;

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

function Executar(Comando:String;ExibirResposta:Boolean;ExibirErro:Boolean):
String;
var
  Resposta: String;
begin
  Resposta:= '';

  if not RunCommand(Comando,Resposta) and (ExibirErro) then
  begin
    MessageDlg('Executar','Erro ao executar o comando:' + sLineBreak +
               Comando, mtError,[mbOK],0);
  end
  else if ExibirResposta then
  begin
    if RunCommand(Comando,Resposta) then
    MessageDlg('Executar','Comando executado. Resposta: ' + sLineBreak +
               Resposta, mtInformation,[mbOK],0);
  end
  else
  begin
    RunCommand(Comando,Resposta)
  end;

  result:= Resposta;
end;

function VerificarArquivos:Boolean;
begin
  result:= false;

  // Verifica o Arquivo
  if frmPrincipal.edtArquivo.Text = '' then
  begin
    MessageDlg('Aviso','Por favor, selecione um arquivo para assinar.',
               mtWarning,[mbOK],0);
  end
  else if LowerCase(ExtractFileExt(frmPrincipal.edtArquivo.Text)) <> '.pdf' then
  begin
    MessageDlg('Aviso','O arquivo que você selecionou não é um PDF. Por favor,'+
               ' selecione um arquivo com a extensão PDF.',mtWarning,[mbOK],0);
  end
  else if not FileExists(frmPrincipal.edtArquivo.Text) then
  begin
   MessageDlg('Aviso','O arquivo que você selecionou não exite. Por favor, ' +
              'selecione um arquivo existente.',mtWarning,[mbOK],0);
  end

  // Verifica a Imagem
  else if not (frmPrincipal.edtImagem.Text = '')        and not
              (FileExists(frmPrincipal.edtImagem.Text)) then
  begin
   MessageDlg('Aviso','A imagem que você selecionou não exite. Por favor, ' +
              'selecione um arquivo existente.',mtWarning,[mbOK],0);
  end
  else if not (frmPrincipal.edtImagem.Text = '') and
              (LowerCase(ExtractFileExt(frmPrincipal.edtImagem.Text)) <> '.png')
              then
  begin
   MessageDlg('Aviso','A imagem que você selecionou não é válida. ' +
              'Por favor, selecione uma imagem PNG.',mtWarning,[mbOK],0);
  end

  // Verifica o JsignPdf
  else if not FileExists(frmPrincipal.edtJsignpdf.Text) then
  begin
   MessageDlg('Erro','O programa JsignPDF não foi encontrado em seu '     +
              'computador! Por favor verifique a instalção ou o caminho ' +
              'do JsignPDF em "Mais opções".',mtError,[mbOK],0);
  end

  // Verifica o Java
  else if not FileExists(frmPrincipal.edtJava.Text) then
  begin
    MessageDlg('Erro','O Java não foi encontrado em seu computador! '  +
               'Por favor verifique a instalção ou o caminho do Java ' +
               'em "Mais opções"',mtError,[mbOK],0);
  end

  // Verifica se existe algum arquivo assinado
  else if (FileExists(ExtractFileNameWithoutExt(frmPrincipal.edtArquivo.Text) +
                                                '_assinado.pdf'))            and
          (MessageDlg('Alera','O arquivo "' +
                      ExtractFileNameWithoutExt(frmPrincipal.edtArquivo.Text)  +
                      '_assinado.pdf" já existe. Se você sobrescrevê-lo, irá ' +
                      'excluir permanentemente o arquivo já existente. Deseja '+
                      'continuar e sobrescrevê-lo? ',
                      mtConfirmation,[mbYes,mbNo],0) = mrNo)                then
  begin
    Exit;
  end

  // Todas as validações foram positivas
  else
  begin
    result:= true;
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

function MontaComandoAssinar:String;
var
  Java             : String;
  JsignPDF         : String;
  Senha            : String;
  Texto            : String;
  Posicao          : String;
  Imagem           : String;
  KeyStoreType     : String;
  ManterAssinaturas: String;
  Parametros       : String;
  Arquivo          : String;
begin
  if VerificarArquivos then
  begin
    // Define variáveis com base nas informações dos campos de texto
    Arquivo          := '"' + frmPrincipal.edtArquivo.Text  + '"';
    Senha            :=       frmPrincipal.edtSenha.Text         ;
    Texto            :=       frmPrincipal.memTexto.Caption      ;
    Imagem           :=       frmPrincipal.edtImagem.Text        ;
    JsignPDF         := '"' + frmPrincipal.edtJsignpdf.Text + '"';
    Java             := '"' + frmPrincipal.edtJava.Text     + '"';
    ManterAssinaturas:= '';

    // Prepara os parâmetros
    if frmPrincipal.ckbManterAssinaturas.Checked
                    then ManterAssinaturas:= ' --append';
    if Senha  <> '' then Senha := ' --keystore-password "' + Senha  + '"';

    if frmPrincipal.rdbDome.Checked then
    begin
      Posicao:= ' -llx 105 -lly 26 -urx 560 -ury 0'; // Posição padrão do DOMe
      Imagem := '';                                 // Não exibe a imagem
      Texto  := ' --l2-text "Assinado digitalmente conforme Lei nº 2.313/2013' +
                ' e Decreto nº 5.628/2013"';        // Texto padrão do DOMe
    end
    else
    begin
      if Imagem <> '' then Imagem:= ' --render-mode GRAPHIC_AND_DESCRIPTION' +
                                    ' --img-path "' + Imagem + '"'  ;
      case Texto  <> '' of
        true : Texto:= ' --l2-text "'  + Texto  + '"';
        false: Texto:= ' --l2-text "Assinado digitalmente por ${signer}"';
      end;

      if frmPrincipal.rdbEsquerda.Checked then Posicao:= ' -llx -10 -urx 250';
      if frmPrincipal.rdbCentro.Checked   then Posicao:= ' -llx 153 -urx 403';
      if frmPrincipal.rdbDireita.Checked  then Posicao:= ' -llx 312 -urx 562';
      Posicao:=                                Posicao + ' -lly 095 -ury 055';
    end;

    if SistemaOperacional = 'Linux' then
    begin
      Java        := Java + ' -jar'; // Adiciona parâmetro para arquivos .jar
      KeyStoreType:= ' PKCS11';      // Define que será do tipo token
    end
    else if SistemaOperacional = 'Windows' then
    begin
      Senha       := '';            // Ignora a senha para o Windows solicitar
      KeyStoreType:= ' WINDOWS-MY'; // Deixa o Windows selecionar o certificado
    end;

    // Define os parâmetros fixos
    Parametros:= ' --keystore-type' + KeyStoreType                        +
                 ' --hash-algorithm SHA256'                               +
                 ' --visible-signature'                                   +
                 ' --font-size 9'                                         +
                 ' --out-suffix "_assinado"'                              +
                 ' --page 999'                                            +
                 ' --out-directory '                                      +
                 '"' + ExtractFilePath(frmPrincipal.edtArquivo.Text) + '"';

    // Define os parâmetros informados pelo usuário
    Parametros:= Parametros + Posicao + Texto + Senha + Imagem +
                 ManterAssinaturas;

    // Monta a linha de comando
    result:=  Java + ' ' + JsignPDF + ' ' + Parametros + ' ' + Arquivo;
  end
end;

procedure AssinarArquivo;
var
  Resposta: String;
begin
  if VerificarArquivos then
  begin
    Resposta:= Executar(MontaComandoAssinar,false,false);
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  DefinirVariaveisGlobais;
  CarregarOpcoes;
end;

procedure TfrmPrincipal.tgbExibirChange(Sender: TObject);
begin
  case tgbExibir.Checked of
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
  AssinarArquivo;
end;

procedure TfrmPrincipal.btnImagemSelecionar1Click(Sender: TObject);
begin
  if opdImagem.Execute then edtImagem.Text:= opdImagem.Filename;
end;

procedure TfrmPrincipal.btnJavaSelecionarClick(Sender: TObject);
begin
  if opdJava.Execute then edtJava.Text:= opdJava.Filename;
end;

procedure TfrmPrincipal.btnJsignpdfSelecionarClick(Sender: TObject);
begin
  if opdJsignpdf.Execute then edtJsignpdf.Text:= opdJsignpdf.Filename;
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
