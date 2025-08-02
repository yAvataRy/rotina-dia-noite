ifndef msg
$(error Voce precisa passar a mensagem do commit usando: make commit/main msg="sua mensagem")
endif

commit/main:
	git add .
	git commit -m "$(msg)"
	git push

