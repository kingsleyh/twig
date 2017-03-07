import std.stdio;
import std.getopt;
import std.file;

string gen;
string output;
bool showHelp = false;

class Twig{

  string name;
  string path;

  public void generate(string gen, string path){
    this.name = gen;
    this.path = path;
    writeln("generating scaffold into: " ~ path ~ "/" ~ gen);
    genMain();
    genMessages();
    genModels();
    genView();
    genUpdate();
  }

  private void genFile(string kind, string content){
    auto dest = this.path ~ "/" ~ this.name;
    if(!exists(dest)){
      mkdirRecurse(dest);
    }
    auto targetFile = dest ~ "/" ~ kind ~ ".elm";
    auto f = File(targetFile, "w");
    writeln("generating: " ~ targetFile);
    f.write(content);
  }

  private void genMain(){
auto content =
`
module ` ~ this.name ~ `.Main exposing (..)

import Html
import ` ~ this.name ~ `.View exposing (view)
import ` ~ this.name ~ `.Update exposing (update)
import ` ~ this.name ~ `.Models exposing (Model, newModel)
import ` ~ this.name ~ `.Messages exposing (Msg(..))


main : Program Never Model Msg
main =
    Html.program
        { init = ( newModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
`;

  genFile("Main", content);

  }

  private void genMessages(){
auto content =
`
module ` ~ this.name ~ `.Messages exposing (..)


type Msg
    = NoOp

`;

  genFile("Messages", content);

  }

  private void genModels(){
auto content =
`
module ` ~ this.name ~ `.Models exposing (..)


type alias Model =
    { something : String }


newModel : Model
newModel =
    Model ""

`;

  genFile("Models", content);

  }

  private void genUpdate(){
auto content =
`
module ` ~ this.name ~ `.Update exposing (..)

import ` ~ this.name ~ `.Models exposing (..)
import ` ~ this.name ~ `.Messages exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

`;

  genFile("Update", content);

  }

  private void genView(){
auto content =
`
module ` ~ this.name ~ `.View exposing (..)

import Html exposing (..)
import ` ~ this.name ~ `.Messages exposing (Msg(..))
import ` ~ this.name ~ `.Models exposing (..)


view : Model -> Html Msg
view model =
    div [] [ text "Hello World!" ]

`;

  genFile("View", content);

  }

}

void main(string[] args)
{

  showHelp = args.length == 1;

  arraySep = ",";
  auto helpInformation = getopt(
    args,
    "generate|g", "Generates a scaffold directory for the supplied name e.g. twig -g AboutTheBusiness", &gen,
    "output|o", "Output location - specify the location the new scaffold folder will be generated into e.g. twig -o /some/path/ -g AboutTheBusiness", &output
  );

  if(helpInformation.helpWanted || showHelp)
  {
    defaultGetoptPrinter("Twig - elm scaffold utility", helpInformation.options);
  }

  auto twig = new Twig();

  if(gen){
    auto path = ".";
    if(output){
      path = output;
    }
    twig.generate(gen, path);
  }

}
