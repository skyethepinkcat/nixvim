{ lib, ... }: {
  autoGroups = {
    ErbFiles = { };
  };
  extraConfigLua = ''
    vim.cmd('syntax on')
  '';
  autoCmd = [
    {
      event = "Syntax";
      group = "ErbFiles";

      callback = lib.nixvim.mkRaw ''
        function(args)
        local saved = vim.b.current_syntax
        local name = vim.api.nvim_buf_get_name(args.buf)
        if not name:match('%.erb$') then return end
        vim.b.current_syntax = nil
        vim.cmd([[
          syntax include @Ruby syntax/ruby.vim
          syntax region erbTag matchgroup=PreProc start="<%=\?-\?" end="-\?%>" contains=@Ruby containedin=ALL keepend
          syntax region Comment matchgroup=Comment start=+<%#+ end=+%>+ contains=Comment containedin=ALL keepend
        ]])
        vim.b.current_syntax = saved
        end
      '';
    }
  ];
}
