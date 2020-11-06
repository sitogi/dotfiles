function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert -m default jj backword-char force-repaint
end

bind -M default \cg accept-autosuggestion
bind -M insert \cg accept-autosuggestion

