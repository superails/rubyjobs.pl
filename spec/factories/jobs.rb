FactoryBot.define do
  factory :job do
    title { "MyString" }
    salary { "MyString" }
    salary_type { "MyString" }
    description { "MyString" }
    apply_link { "MyString" }
    company
    email { "marcin@rubyjobs.pl" }
    remote { "1" }
    location { "Warszawa, Białystok" }
  end
end
