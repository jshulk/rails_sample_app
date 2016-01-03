module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    puts "digest check"
    puts User.digest('password')
    puts User.digest('password')
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
    puts "came to else"
      user = User.find_by(id: user_id)
      puts user.name
      puts "remember_token - #{cookies[:remember_token]}"
      puts "user's remember_digest - #{user.remember_digest}"
      if user && user.authenticated?(cookies[:remember_token])
        puts "user authenticated?"
        log_in user
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
  end
  
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
