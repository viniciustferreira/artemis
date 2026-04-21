require "rails_helper"

# Testes do UsersController cobrindo as actions new, create e show
RSpec.describe UsersController, type: :controller do
  # Parâmetros válidos: nome e email preenchidos corretamente
  let(:valid_params) { { user: { name: "João Silva", email: "joao@example.com" } } }

  # Parâmetros inválidos: campos em branco, deve falhar na validação do model
  let(:invalid_params) { { user: { name: "", email: "" } } }

  # -------------------------
  # GET /users/new
  # -------------------------
  describe "GET #new" do
    it "retorna status HTTP 200" do
      get :new
      # Verifica que a rota respondeu com sucesso
      expect(response).to have_http_status(:success)
    end

    it "atribui um novo User ao @user" do
      get :new
      # Verifica que @user é um objeto User não persistido (novo)
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renderiza o template new" do
      get :new
      # Verifica que a view correta foi renderizada
      expect(response).to render_template(:new)
    end
  end

  # -------------------------
  # POST /users
  # -------------------------
  describe "POST #create" do
    context "com parâmetros válidos" do
      it "cria um novo usuário no banco de dados" do
        # Verifica que o número de usuários aumentou em 1 após o POST
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "redireciona para a tela de visualização do usuário criado" do
        post :create, params: valid_params
        # Verifica que foi redirecionado para /users/:id do usuário recém-criado
        expect(response).to redirect_to(user_path(User.last))
      end

      it "exibe mensagem de sucesso" do
        post :create, params: valid_params
        # Verifica que a flash notice de sucesso foi definida
        expect(flash[:notice]).to match(/sucesso/)
      end
    end

    context "com parâmetros inválidos" do
      it "não cria usuário no banco de dados" do
        # Verifica que o número de usuários NÃO mudou (validação bloqueou)
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it "renderiza o formulário novamente com status 422" do
        post :create, params: invalid_params
        # Verifica que voltou para o form com status Unprocessable Entity
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end

      it "atribui o usuário com erros ao @user" do
        post :create, params: invalid_params
        # Verifica que @user tem erros de validação para serem exibidos na view
        expect(assigns(:user).errors).not_to be_empty
      end
    end
  end

  # -------------------------
  # GET /users/:id
  # -------------------------
  describe "GET #show" do
    # Cria um usuário real no banco de dados de teste para o show
    let(:user) { create(:user) }

    it "retorna status HTTP 200" do
      get :show, params: { id: user.id }
      # Verifica que a rota respondeu com sucesso
      expect(response).to have_http_status(:success)
    end

    it "atribui o usuário correto ao @user" do
      get :show, params: { id: user.id }
      # Verifica que @user é o usuário buscado pelo ID
      expect(assigns(:user)).to eq(user)
    end

    it "renderiza o template show" do
      get :show, params: { id: user.id }
      # Verifica que a view correta foi renderizada
      expect(response).to render_template(:show)
    end
  end
end
