// Controller Stimulus para o botão de conexão com o Google Calendar
// Exibe estado de carregamento enquanto redireciona para a tela de autorização do Google
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Declara os alvos (elementos HTML) que este controller vai manipular
  // "button" corresponde a data-google-calendar-target="button" no botão de submit
  static targets = ["button"];

  // Chamado automaticamente quando o formulário é enviado (via data-action no form)
  // Desabilita o botão e exibe mensagem de aguardo enquanto o redirecionamento acontece
  connecting() {
    if (this.hasButtonTarget) {
      // Desabilita o botão para evitar múltiplos cliques durante o redirecionamento
      this.buttonTarget.disabled = true;
      // Atualiza o texto para informar o usuário que a conexão está sendo iniciada
      this.buttonTarget.value = "Conectando...";
    }
  }
}
