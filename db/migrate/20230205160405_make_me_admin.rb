class MakeMeAdmin < ActiveRecord::Migration[7.0]
  def change
    User.connection.execute("UPDATE users SET admin = 'true' WHERE email = 'lichie_lich@mail.ru'")
  end
end
