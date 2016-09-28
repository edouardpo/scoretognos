ActiveAdmin.register Team do
  actions :index, :new, :create, :edit, :update
  permit_params :championship_id, :name
end
