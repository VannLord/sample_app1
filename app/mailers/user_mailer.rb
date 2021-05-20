class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("index.account_activation")
  end

  def password_reset; end
end
