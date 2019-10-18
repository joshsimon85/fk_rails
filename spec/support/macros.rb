def current_user
  User.find(session[:user_id])
end

def sign_in_flow(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def sign_out_flow
  visit sign_out_path
end
