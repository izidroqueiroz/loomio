ActiveAdmin.register User do

  actions :index, :edit, :update, :show
  filter :name
  filter :email
  filter :created_at

  scope :all
  scope :coordinators

  index do
    column :name
    column :email
    column :created_at
    column :last_sign_in_at
    column "No. of groups", :memberships_count
    column :deleted_at
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :email
      f.input :username
      f.input :is_admin
    end
    f.actions
  end

  member_action :update, :method => :put do
    user = User.find(params[:id])
    user.name = params[:user][:name]
    user.email = params[:user][:email]
    user.username = params[:user][:username]
    user.is_admin = params[:user][:is_admin]
    user.save
    redirect_to admin_users_url, :notice => "User updated"
  end

  show do |user|
    panel("Deactivate") do
      if can? :deactivate, user
        button_to 'Deactivate User', deactivate_admin_user_path(user), method: :put
      else
        div "This user cannot be deactivated because they are currently the only coordinator of at least one of the following groups:"
        table_for user.adminable_groups.each do |group|
          column :id
          column :name
          column "Coordinator Count" do |group|
            group.admins.count
          end
        end
      end
    end
    attributes_table do
      user.attributes.each do |k,v|
        row k.to_sym if v.present?
      end
    end
    active_admin_comments
  end

  member_action :deactivate, method: :put do
    user = User.find(params[:id])
    user.deactivate!
    redirect_to admin_users_url, :notice => "User account deactivated"
  end
  
  csv do
    column :id
    column :name
    column :email
    column :created_at
    column :last_sign_in_at
    column "Coordinator" do |user|
      user.adminable_groups.any?
    end
    column :memberships_count
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
