ActiveAdmin.register Championship do
  actions :index, :new, :create, :edit, :update
  permit_params :name, :start_date, :end_date
end
