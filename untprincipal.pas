unit untPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  AnchorDockPanel;

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
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }




end.

