class AddIntegrationsToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :integration_unifi, :boolean, default: true
    add_column :settings, :integration_openmesh, :boolean, default: false
    add_column :settings, :integration_vsz, :boolean, default: false
    add_column :settings, :integration_meraki, :boolean, default: false
    add_column :settings, :integration_ct, :boolean, default: false
  end
end
