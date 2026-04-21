class UsersController < ApplicationController
  # Exibe o formulário em branco para criação de novo usuário
  def new
    # Inicializa um objeto User vazio para o formulário
    @user = User.new
  end

  # Recebe os dados do formulário e tenta salvar o usuário
  def create
    # Constrói o usuário com os parâmetros permitidos (strong parameters)
    @user = User.new(user_params)

    if @user.save
      # Se salvo com sucesso, redireciona para a tela de visualização do usuário
      redirect_to user_path(@user), notice: "Usuário criado com sucesso!"
    else
      # Se houve erros de validação, renderiza o formulário novamente com status 422
      render :new, status: :unprocessable_entity
    end
  end

  # Exibe os dados de um usuário já existente
  def show
    # Busca o usuário pelo ID informado na URL (ex: /users/1)
    @user = User.find(params[:id])
  end

  private

  # Define quais campos do formulário são permitidos (proteção contra mass assignment)
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
