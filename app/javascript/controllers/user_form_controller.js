// Controller Stimulus para o formulário de criação de usuário
// Previne duplo envio desabilitando o botão enquanto o form é processado
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Declara os alvos (elementos HTML) que este controller vai manipular
  // "submit" corresponde a data-user-form-target="submit" no botão do formulário
  static targets = ["submit"];

  // Chamado automaticamente quando o formulário é enviado (via data-action no form)
  // Desabilita o botão de submit para evitar que o usuário clique duas vezes
  handleSubmit() {
    if (this.hasSubmitTarget) {
      // Desabilita o botão para bloquear novo clique durante o processamento
      this.submitTarget.disabled = true;
      // Atualiza o texto para indicar que está em progresso
      this.submitTarget.value = "Criando...";
    }
  }
}
