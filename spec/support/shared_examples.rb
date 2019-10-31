shared_examples 'requires admin' do
  it 'redirects to home page' do
    user = Fabricate(:user)
    sign_in(user)
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples 'requires sign in' do
  it 'redirects to the sign in page' do
    action
    expect(response).to redirect_to new_user_session_path
  end
end
