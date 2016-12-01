FactoryGirl.define do
  factory :user do
    name FFaker::Name.name
    association :team
    email { FFaker::Internet.email }
    password "hello"
    password_confirmation "hello"

    factory :correct_user_params do
      email { FFaker::Internet.email }
      password "hello"
      password_confirmation "hello"
    end

    factory :wrong_user_params do
      email { FFaker::Internet.email }
      passowrd nil
      password_confirmation nil
    end

    factory :mismatch_passowrd_user_params do
      email { FFaker::Internet.email }
      password "hello"
      password_confirmation "NO-hello"
    end

    factory :user_with_origin_111 do
      origin_user_id "111"
    end
  end


end
