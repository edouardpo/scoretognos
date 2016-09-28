ActiveAdmin.register Day do
  actions :index, :new, :create, :edit, :update
  permit_params :championship_id, :date, :status, :name
end
