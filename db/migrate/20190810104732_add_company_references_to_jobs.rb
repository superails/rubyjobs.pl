class AddCompanyReferencesToJobs < ActiveRecord::Migration[5.2]
  def change
    add_reference :jobs, :company, foreign_key: true
    add_column :jobs, :email, :string
  end
end
