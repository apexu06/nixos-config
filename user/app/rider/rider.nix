{
  pkgs,
  settings,
  ...
}: let
  rider-picker = pkgs.writeShellScriptBin "rider-picker" ''
    SELECTION=$(${pkgs.fd}/bin/fd --extension sln . $HOME/coding | ${pkgs.fzf}/bin/fzf --prompt="Select Solution > ")

    if [ -n "$SELECTION" ]; then
        PROJECT_DIR=$(dirname "$SELECTION")
        cd "$PROJECT_DIR" || exit
        if command -v direnv >/dev/null; then
          eval "$(direnv export bash)"
        fi

        # 2. Check for Flake and launch Rider
        if [ -f "flake.nix" ]; then
            # We use 'nix develop --command' so Rider inherits the project-specific SDK
            # 'rider' must be in your system path or added to packages below
            nix develop --command sh -c "rider \"$SELECTION\""
        else
            rider "$SELECTION"
        fi

        sleep 5
        exit
    fi
  '';
in {
  home.packages = with pkgs; [
    fd
    fzf
    jetbrains.rider
  ];

  home.file.".config/ideavim/ideavimrc".text = ''
    let mapleader=" "

    set mini-ai

    set so=5
    set incsearch

    map <leader>e <Action>(ShowErrorDescription)
    map <Esc> :nohlsearch<CR>
    map <C-k> <Action>(ShowHoverInfo)
    map <leader>sf <Action>(GotoFile)
    map <leader>sg <Action>(TextSearchAction)
    map <leader>sa <Action>(SearchEverywhere)
    map <leader>rn <Action>(RenameElement)
    map <leader>rf <Action>(Refactorings.QuickListPopupAction)
    map <leader>ca <Action>(ShowIntentionActions)
    map <leader>ge <Action>(GotoNextError)
    map <silent>L :bnext<CR>
    map <silent>H :bprev<CR>
    map <leader>b :bd<CR>
    map <leader>mr <Action>(Run)

    map <leader>gi <Action>(ReSharperGotoImplementation)
    map <leader>gd <Action>(GotoDeclaration)
    map <leader>gu <Action>(FindUsages)

    map <leader>xx <Action>(ActivateProblemsViewToolWindow)
    map <leader>t :NERDTreeToggle<CR>


    Plug 'machakann/vim-highlightedyank'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'tpope/vim-surround'
    Plug 'preservim/nerdtree'
  '';

  xdg.desktopEntries.rider-picker = {
    name = "Rider Project Picker";
    genericName = "C# IDE Launcher";
    exec = "${settings.terminal} --title=\"RiderPicker\" -e ${rider-picker}/bin/rider-picker";
    icon = "com.jetbrains.Rider";
    terminal = false;
    categories = ["Development" "IDE"];
    mimeType = ["text/x-csharp"];
  };
}
