{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    fzf
    jetbrains.idea
  ];

  home.file.".config/ideavim/ideavimrc".text = ''
    let mapleader=" "

    set mini-ai

    set so=5
    set incsearch

    map <leader>e <Action>(ShowErrorDescription)
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
}
