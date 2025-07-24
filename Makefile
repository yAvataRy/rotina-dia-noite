# Makefile para facilitar commits e push para o branch main

# -------------------------
# COMO INICIAR UM NOVO REPOSITÓRIO GIT
# -------------------------
# 1. git init                                  # Inicia o repositório local
# 2. git remote add origin git@github.com:yAvataRy/rotina-dia-noite.git
#    - Use a URL SSH (e não HTTPS) para evitar o erro:
#      "Repository not found" ao fazer push
#    - Se você já adicionou um origin errado (ex: com HTTPS), corrija com:
#      git remote set-url origin git@github.com:yAvataRy/rotina-dia-noite.git
#
# 3. git branch -M main                        # Garante que o branch principal se chama main
# 4. git add . && git commit -m "first commit"  # Adiciona arquivos e cria o primeiro commit
# 5. git push -u origin main                   # Faz push para o GitHub
#
# -------------------------
# ERROS COMUNS:
# -------------------------
# ❌ git push origin main
# -> remote: Repository not found.
# -> fatal: repository 'https://github.com/yAvataRy/rotina-dia-noite.git/' not found
#
# ✅ Solução:
# -> Use a URL SSH corretamente com:
#    git remote set-url origin git@github.com:yAvataRy/rotina-dia-noite.git
# -> Ou adicione o origin certo:
#    git remote add origin git@github.com:yAvataRy/rotina-dia-noite.git
#
# ✅ Verifique sua URL com:
#    git remote -v

# ❌ Erro ao executar: git push -u origin main
# Mensagem:
# git@github.com: Permission denied (publickey).
# fatal: Could not read from remote repository.
# Please make sure you have the correct access rights
# and the repository exists.
#
# ✅ Solução:
# - Verifique se você possui uma chave SSH configurada no seu computador.
# - Adicione sua chave SSH à sua conta do GitHub (https://github.com/settings/keys).
# - Confirme se está usando a URL SSH correta:
#     git remote set-url origin git@github.com:yAvataRy/rotina-dia-noite.git
# - Teste sua conexão com:
#     ssh -T git@github.com
# -------------------------
# COMANDO MAKE:
# -------------------------
# Exemplo: make commit/main msg="sua mensagem de commit"
# Isso irá adicionar, commitar e enviar para o branch main

# Cria novo repositório Git
init:
	git init
	git branch -M main

# Define origin com SSH
set-origin:
	git remote set-url origin git@github.com:yAvataRy/rotina-dia-noite.git

# Mostra URL atual
origin:
	git remote -v



ifndef msg
$(error Voce precisa passar a mensagem do commit usando: make commit/main msg="sua mensagem")
endif

commit/main:
	git add .
	git commit -m "$(msg)"
	git push

