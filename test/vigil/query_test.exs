defmodule VigilTest.QueryTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Vigil.Query

  doctest Vigil.Query

  defp get_conn(request_type \\ :post, query)

  defp get_conn(:post, query) do
    :post
    |> conn("/graphql")
    |> Map.put(:body_params, %{"query" => query})
  end

  defp get_conn(:get, query) do
    uri = %URI{path: "/graphql", query: URI.encode_query(%{query: query})}

    :get
    |> conn(uri)
    |> fetch_query_params()
  end

  describe "has_introspection_type?/1" do
    test "is false for the string 'foo'" do
      assert Query.safe?(get_conn("foo"))
    end

    test "is false for the string '__foo'" do
      assert Query.safe?(get_conn("__foo"))
    end

    test "is true for the string '__schema'" do
      refute Query.safe?(get_conn("__schema"))
    end

    test "is true for the string '__type'" do
      refute Query.safe?(get_conn("__type"))
    end

    test "is true for the string '__typekind'" do
      refute Query.safe?(get_conn("__typekind"))
    end

    test "is true for the string '__field'" do
      refute Query.safe?(get_conn("__field"))
    end

    test "is true for the string '__inputvalue'" do
      refute Query.safe?(get_conn("__inputvalue"))
    end

    test "is true for the string '__enumvalue'" do
      refute Query.safe?(get_conn("__enumvalue"))
    end

    test "is true for the string '__directive'" do
      refute Query.safe?(get_conn("__directive"))
    end

    test "is true for the string '__Schema'" do
      refute Query.safe?(get_conn("__Schema"))
    end

    test "is true for the string '__Type'" do
      refute Query.safe?(get_conn("__Type"))
    end

    test "is true for the string '__Typekind'" do
      refute Query.safe?(get_conn("__Typekind"))
    end

    test "is true for the string '__Field'" do
      refute Query.safe?(get_conn("__Field"))
    end

    test "is true for the string '__Inputvalue'" do
      refute Query.safe?(get_conn("__Inputvalue"))
    end

    test "is true for the string '__Enumvalue'" do
      refute Query.safe?(get_conn("__Enumvalue"))
    end

    test "is true for the string '__Directive'" do
      refute Query.safe?(get_conn("__Directive"))
    end

    test "is true for the string '__SCHEMA'" do
      refute Query.safe?(get_conn("__SCHEMA"))
    end

    test "is true for the string '__TYPE'" do
      refute Query.safe?(get_conn("__TYPE"))
    end

    test "is true for the string '__TYPEKIND'" do
      refute Query.safe?(get_conn("__TYPEKIND"))
    end

    test "is true for the string '__FIELD'" do
      refute Query.safe?(get_conn("__FIELD"))
    end

    test "is true for the string '__INPUTVALUE'" do
      refute Query.safe?(get_conn("__INPUTVALUE"))
    end

    test "is true for the string '__ENUMVALUE'" do
      refute Query.safe?(get_conn("__ENUMVALUE"))
    end

    test "is true for the string '__DIRECTIVE'" do
      refute Query.safe?(get_conn("__DIRECTIVE"))
    end

    test "is true for the string '__typeKind'" do
      refute Query.safe?(get_conn("__typeKind"))
    end

    test "is true for the string '__TypeKind'" do
      refute Query.safe?(get_conn("__TypeKind"))
    end

    test "is true for the string '__inputValue'" do
      refute Query.safe?(get_conn("__inputValue"))
    end

    test "is true for the string '__InputValue'" do
      refute Query.safe?(get_conn("__InputValue"))
    end

    test "is true for the string '__enumValue'" do
      refute Query.safe?(get_conn("__enumValue"))
    end

    test "is true for the string '__EnumValue'" do
      refute Query.safe?(get_conn("__EnumValue"))
    end

    test "is true for the string '__schema{}'" do
      refute Query.safe?(get_conn("__schema{}"))
    end

    test "is true for the string '__type{}'" do
      refute Query.safe?(get_conn("__type{}"))
    end

    test "is true for the string '__typekind{}'" do
      refute Query.safe?(get_conn("__typekind{}"))
    end

    test "is true for the string '__field{}'" do
      refute Query.safe?(get_conn("__field{}"))
    end

    test "is true for the string '__inputvalue{}'" do
      refute Query.safe?(get_conn("__inputvalue{}"))
    end

    test "is true for the string '__enumvalue{}'" do
      refute Query.safe?(get_conn("__enumvalue{}"))
    end

    test "is true for the string '__directive{}'" do
      refute Query.safe?(get_conn("__directive{}"))
    end

    test "is true for the string '__Schema{}'" do
      refute Query.safe?(get_conn("__Schema{}"))
    end

    test "is true for the string '__Type{}'" do
      refute Query.safe?(get_conn("__Type{}"))
    end

    test "is true for the string '__Typekind{}'" do
      refute Query.safe?(get_conn("__Typekind{}"))
    end

    test "is true for the string '__Field{}'" do
      refute Query.safe?(get_conn("__Field{}"))
    end

    test "is true for the string '__Inputvalue{}'" do
      refute Query.safe?(get_conn("__Inputvalue{}"))
    end

    test "is true for the string '__Enumvalue{}'" do
      refute Query.safe?(get_conn("__Enumvalue{}"))
    end

    test "is true for the string '__Directive{}'" do
      refute Query.safe?(get_conn("__Directive{}"))
    end

    test "is true for the string '__SCHEMA{}'" do
      refute Query.safe?(get_conn("__SCHEMA{}"))
    end

    test "is true for the string '__TYPE{}'" do
      refute Query.safe?(get_conn("__TYPE{}"))
    end

    test "is true for the string '__TYPEKIND{}'" do
      refute Query.safe?(get_conn("__TYPEKIND{}"))
    end

    test "is true for the string '__FIELD{}'" do
      refute Query.safe?(get_conn("__FIELD{}"))
    end

    test "is true for the string '__INPUTVALUE{}'" do
      refute Query.safe?(get_conn("__INPUTVALUE{}"))
    end

    test "is true for the string '__ENUMVALUE{}'" do
      refute Query.safe?(get_conn("__ENUMVALUE{}"))
    end

    test "is true for the string '__DIRECTIVE{}'" do
      refute Query.safe?(get_conn("__DIRECTIVE{}"))
    end

    test "is true for the string '__typeKind{}'" do
      refute Query.safe?(get_conn("__typeKind{}"))
    end

    test "is true for the string '__TypeKind{}'" do
      refute Query.safe?(get_conn("__TypeKind{}"))
    end

    test "is true for the string '__inputValue{}'" do
      refute Query.safe?(get_conn("__inputValue{}"))
    end

    test "is true for the string '__InputValue{}'" do
      refute Query.safe?(get_conn("__InputValue{}"))
    end

    test "is true for the string '__enumValue{}'" do
      refute Query.safe?(get_conn("__enumValue{}"))
    end

    test "is true for the string '__EnumValue{}'" do
      refute Query.safe?(get_conn("__EnumValue{}"))
    end

    test "is true for the string '__schema {}'" do
      refute Query.safe?(get_conn("__schema {}"))
    end

    test "is true for the string '__type {}'" do
      refute Query.safe?(get_conn("__type {}"))
    end

    test "is true for the string '__typekind {}'" do
      refute Query.safe?(get_conn("__typekind {}"))
    end

    test "is true for the string '__field {}'" do
      refute Query.safe?(get_conn("__field {}"))
    end

    test "is true for the string '__inputvalue {}'" do
      refute Query.safe?(get_conn("__inputvalue {}"))
    end

    test "is true for the string '__enumvalue {}'" do
      refute Query.safe?(get_conn("__enumvalue {}"))
    end

    test "is true for the string '__directive {}'" do
      refute Query.safe?(get_conn("__directive {}"))
    end

    test "is true for the string '__Schema {}'" do
      refute Query.safe?(get_conn("__Schema {}"))
    end

    test "is true for the string '__Type {}'" do
      refute Query.safe?(get_conn("__Type {}"))
    end

    test "is true for the string '__Typekind {}'" do
      refute Query.safe?(get_conn("__Typekind {}"))
    end

    test "is true for the string '__Field {}'" do
      refute Query.safe?(get_conn("__Field {}"))
    end

    test "is true for the string '__Inputvalue {}'" do
      refute Query.safe?(get_conn("__Inputvalue {}"))
    end

    test "is true for the string '__Enumvalue {}'" do
      refute Query.safe?(get_conn("__Enumvalue {}"))
    end

    test "is true for the string '__Directive {}'" do
      refute Query.safe?(get_conn("__Directive {}"))
    end

    test "is true for the string '__SCHEMA {}'" do
      refute Query.safe?(get_conn("__SCHEMA {}"))
    end

    test "is true for the string '__TYPE {}'" do
      refute Query.safe?(get_conn("__TYPE {}"))
    end

    test "is true for the string '__TYPEKIND {}'" do
      refute Query.safe?(get_conn("__TYPEKIND {}"))
    end

    test "is true for the string '__FIELD {}'" do
      refute Query.safe?(get_conn("__FIELD {}"))
    end

    test "is true for the string '__INPUTVALUE {}'" do
      refute Query.safe?(get_conn("__INPUTVALUE {}"))
    end

    test "is true for the string '__ENUMVALUE {}'" do
      refute Query.safe?(get_conn("__ENUMVALUE {}"))
    end

    test "is true for the string '__DIRECTIVE {}'" do
      refute Query.safe?(get_conn("__DIRECTIVE {}"))
    end

    test "is true for the string '__typeKind {}'" do
      refute Query.safe?(get_conn("__typeKind {}"))
    end

    test "is true for the string '__TypeKind {}'" do
      refute Query.safe?(get_conn("__TypeKind {}"))
    end

    test "is true for the string '__inputValue {}'" do
      refute Query.safe?(get_conn("__inputValue {}"))
    end

    test "is true for the string '__InputValue {}'" do
      refute Query.safe?(get_conn("__InputValue {}"))
    end

    test "is true for the string '__enumValue {}'" do
      refute Query.safe?(get_conn("__enumValue {}"))
    end

    test "is true for the string '__EnumValue {}'" do
      refute Query.safe?(get_conn("__EnumValue {}"))
    end

    test "is true for the string '{foo bar baz __schema bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __schema bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __type bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __type bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __typekind bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __typekind bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __field bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __field bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __inputvalue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __inputvalue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __enumvalue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __enumvalue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __directive bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __directive bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Schema bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Schema bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Type bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Type bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Typekind bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Typekind bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Field bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Field bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Inputvalue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Inputvalue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Enumvalue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Enumvalue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __Directive bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __Directive bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __SCHEMA bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __SCHEMA bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __TYPE bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __TYPE bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __TYPEKIND bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __TYPEKIND bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __FIELD bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __FIELD bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __INPUTVALUE bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __INPUTVALUE bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __ENUMVALUE bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __ENUMVALUE bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __DIRECTIVE bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __DIRECTIVE bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __typeKind bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __typeKind bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __TypeKind bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __TypeKind bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __inputValue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __inputValue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __InputValue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __InputValue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __enumValue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __enumValue bang bamph zork}"))
    end

    test "is true for the string '{foo bar baz __EnumValue bang bamph zork}'" do
      refute Query.safe?(get_conn("{foo bar baz __EnumValue bang bamph zork}"))
    end
  end
end
